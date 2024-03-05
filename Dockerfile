# Use the .NET SDK image as a build stage.
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory in the container.
WORKDIR /app

# Copy the project file and restore dependencies.
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining files and build the application.
COPY . ./
RUN dotnet publish -c Release -o out

# Use the ASP.NET Core runtime image as the final stage.
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Set the working directory in the container.
WORKDIR /app

# Copy the published app from the build stage.
COPY --from=build /app/out .

# Expose the port that the app is listening on.
EXPOSE 80

# Define the command to run the app when the container starts.
ENTRYPOINT ["dotnet", "dotnet-print-appsettings.dll"]
