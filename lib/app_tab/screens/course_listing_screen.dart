import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_chips.dart';
import '../utils/colors.dart';
import 'course_detail_screen.dart';

class CourseListingScreen extends StatefulWidget {
  const CourseListingScreen({Key? key}) : super(key: key);

  @override
  State<CourseListingScreen> createState() => _CourseListingScreenState();
}

class _CourseListingScreenState extends State<CourseListingScreen> {
  final CourseService _courseService = CourseService();
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Enrolled', 'New', 'Popular'];
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      isLoading = true;
    });

    // For demo purposes, using sample data
    courses = _courseService.getSampleCourses();
    _filterCourses();

    setState(() {
      isLoading = false;
    });
  }

  void _filterCourses() {
    switch (selectedFilter) {
      case 'Enrolled':
        filteredCourses = courses.where((c) => c.isEnrolled).toList();
        break;
      case 'New':
        filteredCourses = courses.where((c) => !c.isEnrolled).toList();
        break;
      case 'Popular':
        filteredCourses = courses;
        break;
      default:
        filteredCourses = courses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Courses',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilterChips(
            filters: filters,
            selectedFilter: selectedFilter,
            onFilterSelected: (filter) {
              setState(() {
                selectedFilter = filter;
                _filterCourses();
              });
            },
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadCourses,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        return CourseCard(
                          course: filteredCourses[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailScreen(
                                  course: filteredCourses[index],
                                ),
                              ),
                            ).then((_) => _loadCourses());
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
