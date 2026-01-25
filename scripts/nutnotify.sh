#!/bin/bash
# Script de notificación ejecutado por upsmon.conf de Nutify
# Se monta en /scripts y se llama desde NOTIFYCMD

EVENT="$1"
UPS="$2"
LOGTAG="nutnotify-docker"

# Log en stdout para Docker logs
echo "$(date): $LOGTAG Evento NUT: $EVENT en UPS $UPS"

case "$EVENT" in
    ONBATT)
        echo "$(date): $LOGTAG Corte de energía detectado."
        ;;
    LOWBATT)
        echo "$(date): $LOGTAG Batería baja. Lanzando apagado remoto."
        /scripts/nut-remote-shutdown.sh "$UPS"
        ;;
    ONLINE)
        echo "$(date): $LOGTAG Energía restaurada."
        ;;
    *)
        echo "$(date): $LOGTAG Evento desconocido: $EVENT"
        ;;
esac

exit 0
