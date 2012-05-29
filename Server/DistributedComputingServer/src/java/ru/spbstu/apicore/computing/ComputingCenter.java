package ru.spbstu.apicore.computing;

import java.math.BigDecimal;
import java.math.BigInteger;
import ru.spbstu.clients.ClientsHolder;

/**
 *
 * @author igofed
 */
public class ComputingCenter implements IComputingCenter {

    private int newTaskFrom = 0;
    private int coputingStep = 10;
    private int maxToCompute = 130;

    private ComputingTaskResult totalResult = null;
    
    public ComputingCenter(){
      totalResult = new ComputingTaskResult();  
      totalResult.setUp(BigInteger.ONE);
      totalResult.setDown(BigInteger.ONE);
    }
    
    @Override
    public synchronized ComputingTask getNewTask(Long clientId) {
        ComputingTask task = new ComputingTask();
        
        int taskFrom = -1;
        int taskTo = -1;
        if(newTaskFrom < maxToCompute){
            taskFrom = newTaskFrom;
            taskTo = newTaskFrom + coputingStep - 1;
        }
        task.setFrom(taskFrom);
        task.setTo(taskTo);

        newTaskFrom += coputingStep;
        
        ClientsHolder.self().updateCurrentTask(clientId, task);
        
        return task;
    }

    @Override
    public synchronized void loadComputedTask(Long clientId, ComputingTaskResult result) {
        BigInteger up = result.getUp().multiply(totalResult.getUp());
        BigInteger down = result.getDown().multiply(totalResult.getDown());
        
        totalResult.setUp(up);
        totalResult.setDown(down);
        
        ClientsHolder.self().updateCurrentTask(clientId, null);
    }

    @Override
    public BigDecimal getCurrentResult() {
       BigDecimal pi = new BigDecimal(totalResult.getUp());
       pi.divide(new BigDecimal(totalResult.getDown()));
        
       return pi;
    }
}
