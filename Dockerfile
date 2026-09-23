FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .
RUN dotnet publish quinielatuc/quinielatuc.csproj -c Release -o out -p:EnableWindowsTargeting=true

FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app
COPY --from=build /app/out .

# Instalamos el paquete de Windows Desktop compatible en Linux para que arranque
RUN apt-get update && apt-get install -y wget && \
    wget https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --version 8.0.0 --runtime windowsdesktop

ENV ASPNETCORE_URLS=http://*:$PORT
ENTRYPOINT ["dotnet", "quinielatuc.dll"]