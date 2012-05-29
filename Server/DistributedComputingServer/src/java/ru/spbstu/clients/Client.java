package ru.spbstu.clients;

import ru.spbstu.apicore.computing.ComputingTask;

/**
 *
 * @author igofed
 */
public class Client {

    private ComputingTask currentTask;

    public ComputingTask getCurrentTask() {
        return currentTask;
    }

    public void setCurrentTask(ComputingTask currentTask) {
        this.currentTask = currentTask;
    }
}
