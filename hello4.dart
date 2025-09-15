void main() {
  var fixedList = List<int>.filled(3, 0); //정수만 담는 리스트 길이가 3이고 0으로 채운다
  print(fixedList);
  fixedList[0] = 20;
  print(fixedList);
  // fixedList.add(50); 정적 리스트라서 추가,삭제 불가능
  // fixedList.remove(50);

  var variable1 = <int>[1, 2, 3];
  var variable2 = [1, 2, 3];
  var variable3 = List.empty(growable: true);
  //List.empty 비어있는 리스트를 만들어라
  //growable: true 길이가 가변적인 리스트트
  var variable4 = List<int>.filled(3, 0, growable: true);
  //정수에 값만 들어갈 수 있는 리스트 길이3, 모든요소 0 길이 가변
  print(variable1);
  print(variable2);
  print(variable3);
  print(variable4);
}
