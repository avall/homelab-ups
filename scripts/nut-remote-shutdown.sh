#!/bin/bash
# Script de apagado remoto SSH sin sshpass, usando claves montadas
UPS="$1"
LOGTAG="nut-remote-shutdown"

RUNTIME_THRESHOLD=300  # 5 minutos en segundos

# Consulta estado UPS vía NUT (disponible en el contenedor)
RUNTIME=$(upsc "$UPS" battery.runtime 2>/dev/null | grep -o '[0-9]*')

if [ -z "$RUNTIME" ] || ! [[ "$RUNTIME" =~ ^[0-9]+$ ]]; then
    echo "$(date): $LOGTAG Error obteniendo battery.runtime"
    exit 1
fi

echo "$(date): $LOGTAG battery.runtime: ${RUNTIME}s (threshold: ${RUNTIME_THRESHOLD}s)"

if [ "$RUNTIME" -gt "$RUNTIME_THRESHOLD" ]; then
    echo "$(date): $LOGTAG Suficiente batería restante. No se apaga."
    exit 0
fi

echo "$(date): $LOGTAG ¡UMBRAL CRÍTICO! Iniciando apagado selectivo."

SSH_OPTS="-o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=no"

# Solo los dispositivos SIN batería propia
NODES=("10.10.30.28" "10.10.30.238" "10.10.30.27" "10.10.30.26" "10.10.30.1")
OTHER="10.10.30.211"

shutdown_host() {
    local USER="$1"
    local HOST="$2"
    local CMD="$3"
    echo "$(date): $LOGTAG Apagando $HOST..."
    ssh $SSH_OPTS "${USER}@${HOST}" "$CMD"
    local STATUS=$?
    if [ $STATUS -eq 0 ]; then
        echo "$(date): $LOGTAG ✓ $HOST apagado correctamente."
    else
        echo "$(date): $LOGTAG ✗ Fallo en $HOST (exit $STATUS)."
    fi
}

# Apagar Proxmox cluster (solo nodos listados)
for NODE in "${NODES[@]}"; do
    shutdown_host "root" "$NODE" "/sbin/shutdown -h +0 'Apagado por NUT Docker'"
done

# CloudGateway Unifi
shutdown_host "root" "$UNIFI_CGW" "/sbin/shutdown -h +0 'Apagado por NUT'"

# Otra Raspberry Pi
shutdown_host "pi" "$OTHER" "sudo /sbin/shutdown -h +0 'Apagado por NUT Docker'"

echo "$(date): $LOGTAG Apagado remoto completado. Host Docker procederá al shutdown."
exit 0
