document.getElementById("form-reserva").addEventListener("submit", async function(e){
    e.preventDefault();

    const usuario = document.getElementById("usuario").value;
    const sala = document.getElementById("sala").value;

    const res = await fetch("/api/reservaciones", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({usuario, sala})
    });

    const data = await res.json();
    document.getElementById("respuesta").innerText = data.msg + " -> " + JSON.stringify(data.data);
});

