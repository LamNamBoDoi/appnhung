import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hethong/data/model/body/users_logs.dart';

class AttendanceDayItem extends StatefulWidget {
  final String rawDate;
  final String formattedDate;
  final List<UserLogs> logs;

  const AttendanceDayItem({
    Key? key,
    required this.rawDate,
    required this.formattedDate,
    required this.logs,
  }) : super(key: key);

  @override
  _AttendanceDayItemState createState() => _AttendanceDayItemState();
}

class _AttendanceDayItemState extends State<AttendanceDayItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
  }

  String _calculateDuration(String timeIn, String timeOut) {
    try {
      if (timeOut != "00:00:00") {
        final inParts = timeIn.split(':');
        final outParts = timeOut.split(':');

        final inHour = int.parse(inParts[0]);
        final inMinute = int.parse(inParts[1]);
        final outHour = int.parse(outParts[0]);
        final outMinute = int.parse(outParts[1]);

        final totalMinutes =
            (outHour * 60 + outMinute) - (inHour * 60 + inMinute);
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;

        return '${hours}h${minutes.toString().padLeft(2, '0')}';
      } else {
        return '0h00';
      }
    } catch (e) {
      return '0h00';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                color: Colors.blue[700],
                size: 20,
              ),
            ),
            title: Text(
              widget.formattedDate,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            trailing: RotationTransition(
              turns: _iconTurns,
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.blueGrey[600],
                size: 28,
              ),
            ),
            onExpansionChanged: (expanded) {
              if (expanded) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
            children: [
              // ... (spread operator) để "trải" một danh sách các widget vào trong children.
              // Đây là cách phổ biến để sử dụng ExpansionTile vì nó giúp bạn dễ dàng chèn các widget từ một danh sác
              ...widget.logs
                  .where((log) => log.checkindate == widget.rawDate)
                  .map((log) {
                final timeIn = log.timein ?? '--:--';
                final timeOut = log.timeout ?? '--:--';

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Time In
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vào',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.login,
                                size: 16,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                timeIn,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Time Out
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ra',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 16,
                                color: Colors.red[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                timeOut,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Duration
                      if (timeIn != '--:--' && timeOut != '--:--')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _calculateDuration(timeIn, timeOut),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
