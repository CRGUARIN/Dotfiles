#include "ejercicios.h"
#include <iostream>

// Function 1
void ejercicio1() {
  // Variables A and B for the operations
  int A;
  int B;

  // Asking for A
  std::cout << "\n Executing exercice #1";
  std::cout << "Input number A:";
  std::cin >> A;

  // Asking for B
  std::cout << "Input number B:";
  std::cin >> B;

  // Finding the respective value
  int residuo = A % B;

  // Showing the respective result
  std::cout << "El residulo de la división " << A << "/" << B
            << " es: " << residuo << "\n";
}
