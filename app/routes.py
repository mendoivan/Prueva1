# app/routes.py
from flask import Blueprint, render_template, request, jsonify, redirect, url_for

# Un solo blueprint llamado 'main'
main = Blueprint("main", __name__)

# ===================== LOGIN / INICIO =====================

# Página inicial: muestra el login
@main.route("/")
def index():
    return render_template("index.html")

# Procesar formulario de login
@main.route("/login", methods=["POST"])
def login():
    if not request.form.get("username") or not request.form.get("password"):
        return render_template(
            "index.html",
            error="Usuario y contraseña requeridos"
        ), 400

    # Aquí después validaremos contra la tabla 'usuarios'
    return redirect(url_for("main.dashboard"))

# ===================== DASHBOARD =====================

@main.route("/dashboard")
def dashboard():
    # Más adelante estos valores vendrán de la base de datos
    tickets_abiertos = 0
    visitas_hoy = 0
    equipos_garantia = 0

    return render_template(
        "dashboard.html",
        tickets_abiertos=tickets_abiertos,
        visitas_hoy=visitas_hoy,
        equipos_garantia=equipos_garantia
    )

# ===================== API DE RESERVACIONES (PRUEBA) =====================

@main.route("/api/reservaciones", methods=["POST"])
def crear_reserva():
    data = request.get_json(silent=True) or {}

    if not data.get("usuario") or not data.get("sala"):
        return jsonify({"msg": "Faltan campos requeridos: usuario, sala"}), 400

    return jsonify({"msg": "Reserva creada correctamente", "data": data}), 201

# ===================== MENÚ SUPERIOR =====================

@main.route("/tickets")
def tickets():
    return render_template("tickets.html")

@main.route("/tecnicos")
def tecnicos():
    return render_template("tecnicos.html")

@main.route("/inventario")
def inventario():
    return render_template("inventario.html")

@main.route("/reportes")
def reportes():
    return render_template("reportes.html")

# ===================== ACCIONES RÁPIDAS DEL DASHBOARD =====================

@main.route("/tickets/nuevo")
def crear_ticket():
    return render_template("crear_ticket.html")

@main.route("/tickets/asignar")
def asignar_tecnico():
    return render_template("asignar_tecnico.html")

@main.route("/tickets/evidencia")
def cargar_evidencia():
    return render_template("cargar_evidencia.html")
