FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app

ARG ACCESS_TOKEN
ARG DB_CONECTION_STRING

ENV ACCESS_TOKEN $ACCESS_TOKEN
ENV DB_CONECTION_STRING $DB_CONECTION_STRING

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "TelegramBotNotifierApi.dll"]
