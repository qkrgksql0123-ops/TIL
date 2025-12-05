import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TradeLocationPage extends StatefulWidget {
  const TradeLocationPage({super.key});

  @override
  State<TradeLocationPage> createState() => _TradeLocationPageState();
}

class _TradeLocationPageState extends State<TradeLocationPage> {
  // 핀 위치 (화면 비율로 저장)
  Offset _pinPosition = const Offset(0.5, 0.5); // 초기 위치: 중앙

  void _onTapMap(TapDownDetails details, BoxConstraints constraints) {
    setState(() {
      // 탭한 위치를 비율로 변환
      _pinPosition = Offset(
        details.localPosition.dx / constraints.maxWidth,
        details.localPosition.dy / constraints.maxHeight,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: const Color(0xff212123),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 텍스트
          Container(
            color: const Color(0xff212123),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppFont(
                  '이웃과 만나서\n거래하고 싶은 장소를 선택해주세요.',
                  size: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                AppFont(
                  '만나서 거래할 때는 누구나 찾기 쉬운 공공장소가 좋아요.',
                  size: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ],
            ),
          ),
          // 지도 영역
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) => _onTapMap(details, constraints),
                  child: Stack(
                    children: [
                      // 지도 이미지
                      SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Image.asset(
                          'assets/images/image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 핀 마커
                      Positioned(
                        left: _pinPosition.dx * constraints.maxWidth - 25,
                        top: _pinPosition.dy * constraints.maxHeight - 50,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.deepOrange,
                          size: 50,
                        ),
                      ),
                      // 현재 위치 버튼
                      Positioned(
                        right: 16,
                        bottom: 80,
                        child: GestureDetector(
                          onTap: () {
                            // 중앙으로 이동
                            setState(() {
                              _pinPosition = const Offset(0.5, 0.5);
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 하단 버튼
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Btn(
              onTap: () {
                // 선택된 위치를 문자열로 반환 (실제 앱에서는 주소 검색 API 사용)
                Get.back(result: '덕풍동 342-5 근처');
              },
              child: const Center(
                child: AppFont(
                  '선택 완료',
                  fontWeight: FontWeight.bold,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
