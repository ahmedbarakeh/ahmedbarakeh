import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:task_app/controllers/home_controller.dart';
import 'package:task_app/widgets/backgrounded_text.dart';
import 'package:task_app/widgets/custom_text.dart';
import 'package:task_app/widgets/empty_content.dart';
import 'package:task_app/widgets/main_drawer.dart';
import '../utils/routes.dart';
import '../widgets/task_item.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  var isScrollingUp = true.obs;
  final ScrollController _scrollController = ScrollController();
  final HomeController _homeController = Get.find();

  HomeScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const MainDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.addTaskRoute);
          },
          child: const Center(
              child: Text(
            '+',
            style:
                TextStyle(color: Color.fromRGBO(40, 40, 75, 1), fontSize: 25.0),
          )),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  topContainer(),
                  weekDaysList(),
                  const SizedBox(
                    height: 12,
                  ),
                  tasksList(),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget weekDaysList() {
    return SizedBox(
      height: Get.height * 0.05,
      width: Get.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: weekDays.length,
          itemBuilder: (ctx, index) {
            return Obx(() => BackgroundedText(
                  text: weekDays[index],
                  backgroundColor:
                      _homeController.currentDayIndex.value == index
                          ? mainColor
                          : Colors.orange,
                  textSize: 13.0,
                  onTap: () {
                    _homeController.currentDayIndex(index);
                    _homeController.filterTask(weekDays[index]);
                  },
                ));
          }),
    );
  }

  Widget topContainer() {
    return Obx(() => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        height: isScrollingUp.value ? Get.height * 0.2 : 65,
        width: double.infinity,
        decoration: BoxDecoration(
            color: mainColor, borderRadius: BorderRadius.circular(0)),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            const Spacer(),
            const SizedBox(
              height: 12,
            ),
            if (isScrollingUp.value)
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: isScrollingUp.value ? 1 : 0,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        height: 65,
                        width: 65,
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                                width: 65,
                                height: 65,
                                child: Obx(
                                  () => CircularProgressIndicator(
                                      backgroundColor: Colors.grey,
                                      strokeWidth: 10,
                                      value: _homeController.completionValue.value,
                                      color: Colors.amber),
                                )),
                            Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "${(_homeController.completionValue * 100).toStringAsFixed(0)} %",
                                  style: const TextStyle(
                                      fontFamily: 'Fruit',
                                      fontSize: 18.0,
                                      color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                          const SizedBox(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          CustomText(
                            text: 'Of tasks are completed'.tr,
                            fontFamily: 'Fruit',
                            color: kColorsBlue700,
                            size: 20.0,
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      )
                ]),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                  size: 22,
                ),
                const Icon(Icons.favorite, color: Colors.white, size: 22),
                Obx(() => GestureDetector(
                    onTap: () {
                      _homeController.showTasksAsGrid(
                          !_homeController.showTasksAsGrid.value);
                    },
                    child: Icon(
                        !_homeController.showTasksAsGrid.value
                            ? Icons.grid_view_rounded
                            : Icons.list,
                        color: Colors.white,
                        size: 22))),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        )));
  }

  Widget tasksList() {
    return SizedBox(
        height: Get.height * 0.73,
        child: Obx(() {
          final list = _homeController.currentDayIndex.value == 0
              ? _homeController.tasksList.value
              : _homeController
                  .filterTask(weekDays[_homeController.currentDayIndex.value]);

          if (list.isEmpty && !_homeController.tasksIsLoading.value) {
            return EmptyContent(
              contentTitle: 'tasks'.tr,
              addFunction: () {
                Get.toNamed(Routes.addTaskRoute);
              },
            );
          }
          return _homeController.tasksIsLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (_scrollController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                      isScrollingUp(false);
                      //the setState function
                    } else if (_scrollController.position.userScrollDirection ==
                        ScrollDirection.forward) {
                      isScrollingUp(true);
                      //setState function
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _homeController.fetchAndSetTasks();
                    },
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    child: _homeController.showTasksAsGrid.value
                        ? GridView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              //  childAspectRatio: 4/2,
                            ),
                            itemCount: list.length,
                            itemBuilder: (ctx, index) {
                              return TaskItem(
                                taskModel: list[index],
                                isGridView: true,
                              );
                            })
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (ctx, index) {
                              return TaskItem(
                                taskModel: list[index],
                                isGridView: false,
                              );
                            }),
                  ));
        }));
  }
}
