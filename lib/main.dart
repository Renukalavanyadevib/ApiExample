import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Employee List'),
        ),
        body: FutureBuilder<List<Employee>>(
          future: fetchEmployees(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return EmployeeList(employees: snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Future<List<Employee>> fetchEmployees() async {
    final Dio dio = Dio();
    final Response response = await dio.get('https://dummy.restapiexample.com/api/v1/employees');
    final List<dynamic> data = response.data['data'];
    return data.map((e) => Employee.fromJson(e)).toList();
  }
}

class Employee {
  final int id;
  final String name;
  final int salary;
  final int age;

  Employee({required this.id, required this.name, required this.salary, required this.age});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['employee_name'],
      salary: json['employee_salary'],
      age: json['employee_age'],
    );
  }
}

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;

  const EmployeeList({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final Employee employee = employees[index];
        return ListTile(
          title: Text(employee.name),
          subtitle: Text('Salary: ${employee.salary}, Age: ${employee.age}'),
        );
      },
    );
  }
}
