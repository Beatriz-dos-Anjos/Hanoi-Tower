#include <iostream>
#include <cmath> // para uarpow()
using namespace std;


// Função recursiva que resolve a Torre de Hanói
void hanoi(int n, char inicial = 'A', char meio = 'B', char final = 'C') {
    // Caso base: apenas um disco
    if (n == 1) {
        cout << "Mova disco 1, da Torre " << inicial << " para a Torre " << final << endl;
    } else {
        // Passo 1: mover n-1 discos para a torre auxiliar
        hanoi(n - 1, inicial, final, meio);

        // Passo 2: mover o maior disco para a torre final
        cout << "Mova o disco " << n << ", da Torre " << inicial << " para a Torre " << final << endl;

        // Passo 3: mover os n-1 discos da torre auxiliar para a torre final
        hanoi(n - 1, meio, inicial, final);
    }
}

int main() {
    int n;
    cout << "Insira uma quantidade de discos entre 1 e 9: ";
    cin >> n;

    if (n > 9 || n <= 0) {
        cout << "Número de discos inválido!" << endl;
    } else {
        cout << "Algoritmo da Torre de Hanoi com " << n << " discos" << endl;
        hanoi(n);
        cout << "Concluído!" << endl;

        // Apenas para conferir o número mínimo de movimentos:
        cout << "Número mínimo de movimentos: " << pow(2, n) - 1 << endl;
    }

    return 0;
}
