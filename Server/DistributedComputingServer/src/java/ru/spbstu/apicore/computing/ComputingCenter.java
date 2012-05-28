package ru.spbstu.apicore.computing;

/**
 *
 * @author igofed
 */
public class ComputingCenter implements IComputingCenter{

    @Override
    public ComputingTask getNewTask(Long clientId) {
        return null;
    }

    @Override
    public void loadComputedTask(Long clientId, ComputingTaskResult result) {
        
    }
    
}
