# Use the official .NET SDK as the build environment
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy project files and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the entire project and build the application
COPY . ./
RUN dotnet publish -c Release -o /publish

# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# this specific piece of code came from Jude. 
ENV ASPNETCORE_URLS=http://+:80

COPY --from=build /publish ./

# Expose port 80 and set the entry point
EXPOSE 80
ENTRYPOINT ["dotnet", "DockerWebApi.dll"]