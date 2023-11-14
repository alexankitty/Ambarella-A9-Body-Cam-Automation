import sys
import os
import lib
import logging

from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
from PyQt5.QtCore import QObject, QUrl, Qt, pyqtSlot, pyqtSignal, pyqtProperty

class Manager(QObject):
    stationsChanged = pyqtSignal()
    currentStationChanged = pyqtSignal()
    def __init__(self):
        QObject.__init__(self)
        self.m_stations = []
        self.m_currentStation = ""
        self.currentStationChanged.connect(self.on_currentStationChanged)

    @pyqtProperty(str, notify=currentStationChanged)
    def currentStation(self):
        return self.m_currentStation

    @currentStation.setter
    def currentStation(self, val):
        if self.m_currentStation == val:
            return
        self.m_currentStation = val
        self.currentStationChanged.emit()

    @pyqtProperty(list, notify=stationsChanged)
    def stations(self):
        return self.m_stations

    @stations.setter
    def stations(self, val):
        if self.m_stations == val:
            return
        self.m_stations = val[:]
        self.stationsChanged.emit()

    @pyqtSlot()
    def play(self):
        print("play", self.currentStation)

    @pyqtSlot()
    def stop(self):
        print("stop")

    @pyqtSlot()
    def on_currentStationChanged(self):
        print(self.currentStation)



if __name__ == "__main__":

    os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"

    app = QApplication(sys.argv)

    engine = QQmlApplicationEngine('ui/main.qml')
    manager = Manager()
    ctx = engine.rootContext()
    ctx.setContextProperty("Manager", manager)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())