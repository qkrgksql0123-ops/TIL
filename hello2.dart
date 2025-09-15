// String? bookname;
// void main() {
//   print(bookname?.length);  //! 의 뜻은 이값은 null 값이 아니라는 뜻뜻
// }

late String bookName; // late는 null이 될 수 없는 변수 나중에 초기화

void main() {
  bookName = makeBookName();
  print(bookName.length);
}

String makeBookName() {
  return ("핸즈온 플러터");
}
