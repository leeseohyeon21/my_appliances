import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 샘플 알림 데이터
    final List<Map<String, String>> notifications = [
      {'title': '새로운 업데이트', 'description': '앱에 새로운 업데이트가 있습니다.'},
      {'title': '이벤트 안내', 'description': '특별 이벤트에 참여하세요!'},
      {'title': '예약 알림', 'description': '제품 예약이 완료되었습니다.'},
      {'title': '결제 안내', 'description': '결제가 성공적으로 처리되었습니다.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: notifications.isEmpty
          ? Center(
        child: Text(
          '알림이 없습니다.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(notification['title'] ?? '알림 제목'),
            subtitle: Text(notification['description'] ?? '알림 내용'),
            onTap: () {
              // 알림 클릭 시 동작
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(notification['title'] ?? '알림 제목'),
                  content: Text(notification['description'] ?? '알림 내용'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
