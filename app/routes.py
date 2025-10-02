from flask import Blueprint, render_template, request, jsonify

main = Blueprint("main", __name__)

#Página principal
@main.routes("/")
def index():
    return render_template("index.html")

#Endpoint API para crear reservación
@main.route("/api/reservaciones", methods=["POST"])
def crear_reserva():
    data = request.json
    return jsonify({
        "msg": "Reserva creada correctamente",
        "data": data
    }), 201
