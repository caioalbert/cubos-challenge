#!/bin/bash

echo "Verificando o ambiente..."
echo

echo "Status dos containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo

echo "Redes Docker:"
echo "Internal network:"
docker network inspect internal --format='{{range .Containers}}  - {{.Name}}{{end}}'
echo
echo "External network:"
docker network inspect external --format='{{range .Containers}}  - {{.Name}}{{end}}'
echo

echo "Testando API:"
API_RESPONSE=$(curl -s http://localhost:8080/api)
echo "Response: $API_RESPONSE"

DATABASE_STATUS=$(echo $API_RESPONSE | grep -o '"database":[^,}]*' | cut -d':' -f2)
USER_ADMIN_STATUS=$(echo $API_RESPONSE | grep -o '"userAdmin":[^,}]*' | cut -d':' -f2)

if [ "$DATABASE_STATUS" = "true" ] && [ "$USER_ADMIN_STATUS" = "true" ]; then
    echo "API funcionando corretamente!"
else
    echo "Problemas na API"
fi
echo

echo "Testando Frontend:"
FRONTEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
if [ "$FRONTEND_RESPONSE" = "200" ]; then
    echo "Frontend acessível em http://localhost:8080"
else
    echo "Problemas no frontend"
fi
echo

echo "Verificação completa!"
echo "Acesse: http://localhost:8080"
