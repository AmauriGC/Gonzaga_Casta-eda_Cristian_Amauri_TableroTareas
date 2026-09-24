import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tablero de tareas',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.purpleAccent),
      ),
      home: const TableroTareasPage(title: 'Cosas por hacer'),
    );
  }
}

class TableroTareasPage extends StatefulWidget {
  const TableroTareasPage({super.key, required this.title});

  final String title;

  @override
  State<TableroTareasPage> createState() => _TableroTareasPageState();
}

class Tarea {
  String nombre;
  bool estatus;

  Tarea({required this.nombre, this.estatus = false});
}

class _TableroTareasPageState extends State<TableroTareasPage> {
  final List<Tarea> _tareas = [
    Tarea(nombre: "Tarea uno"),
    Tarea(nombre: "Tarea dos"),
    Tarea(nombre: "Tarea tres"),
    Tarea(nombre: "Tarea cuatro"),
    Tarea(nombre: "Tarea cinco"),
  ];

  int _tareasCompletas = 0;
  bool _soloCompletadas = false;

  void _agregarTarea() {
    setState(() {
      _tareas.add(Tarea(nombre: "Tarea ${_tareas.length + 1}"));
    });
  }

  void _eliminarTarea(int index) {
    setState(() {
      _tareas.removeAt(index);
    });
  }

  void _marcarComoCompletada(int index) {
    setState(() {
      _tareas[index].estatus = true;
      _tareasCompletas = _tareas.where((t) => t.estatus).length;
    });
  }

  void _desmarcarTarea(int index){
    setState(() {
      _tareas[index].estatus = false;
      _tareasCompletas = _tareas.where((t) => t.estatus).length;
    });
  }

  void _desmarcarTodas(){
    setState(() {
      for (var i = 0; i < _tareas.length; i++){
        _tareas[i].estatus = false;
      }
      _tareasCompletas = _tareas.where((t) => t.estatus).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tareasMostradas = _soloCompletadas
        ? _tareas.where((t) => t.estatus).toList()
        : _tareas;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Marcar todas las tareas como no completadas",
            onPressed: _desmarcarTodas,
            icon: const Icon(Icons.restart_alt),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Tareas: ${tareasMostradas.where((t) => t.estatus == true).length}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Switch(
                  value: _soloCompletadas,
                  onChanged: (value) {
                    setState(() {
                      _soloCompletadas = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: tareasMostradas.length,
              itemBuilder: (context, index) {
                final tarea = tareasMostradas[index];
                final indexReal = _tareas.indexOf(tarea);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: CheckboxListTile(
                    value: tarea.estatus,
                    onChanged: (value) {
                      if (value == true) {
                        _marcarComoCompletada(indexReal);
                      } else {
                        _desmarcarTarea(indexReal);
                      }
                    },
                    title: Text(
                      tarea.nombre,
                      style: TextStyle(
                        decoration: tarea.estatus
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    secondary: IconButton(
                      tooltip: "Eliminar",
                      onPressed: () => _eliminarTarea(indexReal),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarTarea,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text("Agregar"),
      ),
    );
  }
}