# Definimos la versión mínima de CMake que necesita el sistema
cmake_minimum_required(VERSION 3.10)

# Nombramos el proyecto
project(Lab1_Info2)

# Indicamos la ruta de los archivos .h
include_directories(include)

# Agrupamos los archivos fuente y le damos nombre al ejecutable
add_executable(Lab1 src/main.cpp src/ejercicios.cpp)
