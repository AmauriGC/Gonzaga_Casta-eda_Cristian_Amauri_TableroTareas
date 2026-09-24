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
      home: const TableroTareasPage(title: 'Cosas por hacer', description: "Hola que hace",),
    );
  }
}

class TableroTareasPage extends StatefulWidget {

  final String title;
  final String description;
  const TableroTareasPage({super.key, required this.title, required this.description});

  @override
  State<TableroTareasPage> createState() => _TableroTareasPageState();
}

class Tarea {
  String nombre;
  String descripcion;
  bool estatus;

  Tarea({required this.nombre, required this.descripcion, this.estatus = false});
}

class _TableroTareasPageState extends State<TableroTareasPage> {
  final List<Tarea> _tareasOriginales = [
    Tarea(nombre: "Tarea uno", descripcion: "Hacer hoy"),
    Tarea(nombre: "Tarea dos", descripcion: "Ya paso"),
    Tarea(nombre: "Tarea tres", descripcion: "Terminar"),
    Tarea(nombre: "Tarea cuatro", descripcion: "Casi casi"),
    Tarea(nombre: "Tarea cinco", descripcion: "No pues no"),
  ];

  late List<Tarea> _tareas = _tareasOriginales;

  late int _tareasCompletas = _tareas.where((t) => t.estatus).length;
  bool _soloCompletadas = false;

  void _agregarTarea() {
    setState(() {
      _tareas.add(Tarea(nombre: "Tarea ${_tareas.length + 1}", descripcion: "Descripción"));
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
      _tareasCompletas;
    });
  }

  void _desmarcarTarea(int index){
    setState(() {
      _tareas[index].estatus = false;
      _tareasCompletas;
    });
  }

  void _desmarcarTodas(){
    setState(() {
      for (var i = 0; i < _tareas.length; i++){
        _tareas[i].estatus = false;
      }
      _tareasCompletas;
    });
  }

  void _restablecerTareasOriginales() {
    setState(() {
      _tareas = _tareasOriginales;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tareasMostradas = _soloCompletadas
        ? _tareas.where((t) => t.estatus).toList()
        : _tareas;

    final textoTareas = _soloCompletadas
        ? "Ver todas las tareas" : "Ver tareas completadas";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        toolbarHeight: 150,
        actions: [
              Column(
                spacing: 0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: "Marcar todas las tareas como no completadas",
                    onPressed: _desmarcarTodas,
                    icon: const Icon(Icons.restart_alt),
                  ),
                  IconButton(
                    tooltip: "Restablecer",
                    onPressed: _restablecerTareasOriginales,
                    icon: const Icon(Icons.clear),
                  ),
                ],
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
                Column(
                  children: [
                    Text(
                      textoTareas
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
                )
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
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea.estatus,
                      onChanged: (value) {
                        if (!tarea.estatus) {
                          _marcarComoCompletada(indexReal);
                        } else {
                          _desmarcarTarea(indexReal);
                        }
                      },
                    ),
                    title: Text(
                          tarea.nombre,
                          style: TextStyle(
                            decoration: tarea.estatus
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                    ),
                    subtitle: Text(
                      tarea.descripcion,
                      style: TextStyle(
                        decoration: tarea.estatus
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
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
        label: Text("Agregar"),
      ),
    );
  }
}