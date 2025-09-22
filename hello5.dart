void main() {
  int? age = null;
  print('나의 나이는 ${age ?? 37}살 입니다다');
  //age ?? 37 ⇔ (age != null) ? age : 37 와 완전히 동일한 의미.
}
