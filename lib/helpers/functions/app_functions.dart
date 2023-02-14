class AppFunctionsHelper {
  int convertRadianToDegree({required double radian}) {
    var degree = radian * 57.2957795131;
    var roundedDegree = degree.round();
    return (90 - roundedDegree);
  }
}
