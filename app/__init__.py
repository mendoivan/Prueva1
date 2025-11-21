# app/__init__.py
from flask import Flask
from pathlib import Path

def create_app():
    base_dir = Path(__file__).resolve().parent

    # Rutas absolutas a templates y static dentro de app/
    app = Flask(
        __name__,
        template_folder=str(base_dir / "templates"),
        static_folder=str(base_dir / "static"),
    )

    from .routes import main
    app.register_blueprint(main)

    # Prueba rápida para verificar que el template loader ve las rutas
    @app.route("/_debug_paths")
    def _debug_paths():
        return {
            "template_folder": app.template_folder,
            "static_folder": app.static_folder,
        }

    return app

