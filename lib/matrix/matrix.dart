import 'dart:math';

class Matrix {
  Matrix(int rows, int cols, this.value);

  Matrix.point(double x, double y)
      : this(1, 3, [
          [x, y, 1]
        ]);

  Matrix.translation(double dx, double dy)
      : this(3, 3, [
          [1,0,0],
          [0,1,0],
          [dx,dy,1],
        ]);

  Matrix.rotation(double angle, double x, double y)
      : this(3, 3, [
    [cos(angle),sin(angle),0,],
    [-sin(angle),cos(angle),0],
    [-x*cos(angle) + y*sin(angle)+x,-x*sin(angle)-y*cos(angle)+y,1],
  ]);

  final List<List<double>> value;

  int get rows => value.length;

  int get cols => value[0].length;

  List<double> operator [](int index) {
    return value[index];
  }

  Matrix operator *(Matrix other) {
    final newValue = List.filled(rows, List.filled(other.cols, 0.0));
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < other.cols; j++) {
        for (int k = 0; k < cols; k++) {
          newValue[i][j] += this[i][k] * other[k][j];
        }
      }
    }
    return Matrix(rows, other.cols, newValue);
  }
}
