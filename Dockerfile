FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .
RUN dotnet publish quinielatuc/quinielatuc.csproj -c Release -o out -p:EnableWindowsTargeting=true

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .
ENV ASPNETCORE_URLS=http://*:$PORT
ENTRYPOINT ["dotnet", "quinielatuc.dll"]