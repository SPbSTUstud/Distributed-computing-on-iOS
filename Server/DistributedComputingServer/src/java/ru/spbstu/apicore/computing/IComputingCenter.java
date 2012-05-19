package ru.spbstu.apicore.computing;

/**
 *
 * @author igofed
 */
public interface IComputingCenter {
    ComputingTask getNewTask(Long clientId);
    void loadComputedTask(Long clientId, ComputingTaskResult result);
}
