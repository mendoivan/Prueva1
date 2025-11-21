# run.py (en la raíz del proyecto)
from app import create_app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True)
#-------------------------------------#
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # Aquí va tu configuración (SECRET_KEY, BD, etc.)

    db.init_app(app)

    # Importar y registrar el blueprint 'main'
    from .routes import main
    app.register_blueprint(main)

    return app
