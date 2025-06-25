from flask import Flask, request, redirect, url_for
import os

UPLOAD_FOLDER = '/var/www/html/anchor.hackserv.cc/public_html/uploads'  # set this to your path
ALLOWED_EXTENSIONS = {'yaml', 'yml', 'json', 'pdf', 'zip', 'tar', 'tar.gz', 'KoTe', 'txt', 'docx', 'pub', 'pem', 'pfx', 'jpg', 'jpeg', 'png'}

app = Flask(_name_)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return 'No file part', 400
    file = request.files['file']
    if file.filename == '':
        return 'No selected file', 400
    if file and allowed_file(file.filename):
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(filepath)
        return redirect(url_for('upload_success'))

@app.route('/upload_success')
def upload_success():
    return 'Upload successful.'

if _name_ == '_main_':
    app.run(host='0.0.0.0', port=5000)
