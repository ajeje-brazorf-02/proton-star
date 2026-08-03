import cv2
import socket
import struct
import pickle
import select  # --- AGGIUNTO: serve per controllare comandi dal server senza bloccare il loop ---
import imutils #type:ignore


client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(('indirizzo ip del server', 2444))

cam = cv2.VideoCapture(0)
img_counter = 0
encode_param=[int(cv2.IMWRITE_JPEG_QUALITY),90]

while True:
    # --- AGGIUNTO: controlla se il server ha inviato un comando di chiusura, senza bloccare il loop ---
    ready_to_read, _, _ = select.select([client_socket], [], [], 0)
    if ready_to_read:
        header = b""
        while len(header) < struct.calcsize(">L"):
            chunk = client_socket.recv(struct.calcsize(">L") - len(header))
            if not chunk:
                break
            header += chunk
        if len(header) < struct.calcsize(">L") or struct.unpack(">L", header)[0] == 0:
            print("Comando di chiusura ricevuto dal server, chiudo il client.")
            break
    # --- FINE AGGIUNTA ---

    ret, frame = cam.read()
    frame = imutils.resize(frame, width=320)
    frame = cv2.flip(frame,180)
    result, image = cv2.imencode('.jpg', frame, encode_param)
    data = pickle.dumps(image, 0)
    size = len(data)

    if img_counter%10==0:
        client_socket.sendall(struct.pack(">L", size) + data)
        
    img_counter += 1

# --- AGGIUNTO: rilascia la webcam e chiude la connessione quando il loop termina ---
cam.release()
client_socket.close()