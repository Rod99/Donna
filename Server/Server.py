from PIL import Image
from flask import request, Flask, jsonify
import numpy as np
import tensorflow as tf
import base64
import os
from flask_cors import CORS, cross_origin
from io import BytesIO


app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


def load_model():
    return tf.keras.models.load_model('/home/rodrigovera/Escritorio/model/Model')


def create_output(model, input):
    img = tf.cast(tf.image.decode_jpeg(tf.io.read_file(input)), tf.float32)[:, :, :3]
    img = tf.image.resize(img, [256, 256])
    img = img / 127.5 - 1
    prediction = model(img[np.newaxis, ...], training=True) * 0.5 + 0.5

    return Image.fromarray(np.asarray((prediction[0, ...] * 255)).astype(np.uint8))


@app.route('/upload', methods=["POST"])
@cross_origin()
def upload():
    if request.method == "POST":
        imagesResults = []  # El arrelo que se mandará de regreso
        NAMETEMP = "temp.jpg"
        # Lo siguiente devuelve un arreglo de base64, que puede contener desde 1 hasta n imagenes
        imagesFiles = request.json[
            'images']  # Aqui por alguna razon me lo detecta como string, no como base64, no se porque
        for image in imagesFiles:
            # Creamos un archivo temporal a partir de la cadena base64
            with open(NAMETEMP, 'wb') as fh:
                fh.write(base64.b64decode(image))
            # image debe de ser la ruta de la imagen
            imagen = create_output(load_model(), NAMETEMP)
            buffered = BytesIO()
            imagen.save(buffered, format="JPEG")
            img_str = base64.b64encode(buffered.getvalue()).decode("utf-8")
            print(img_str)
            imagesResults.append(img_str)
            # Eliminamos la imagen temporal
            os.remove(NAMETEMP)
        return jsonify({
            'statusCode': 200,
            'images': imagesResults
        })


if __name__ == "__main__":
    app.run(port=4000)
