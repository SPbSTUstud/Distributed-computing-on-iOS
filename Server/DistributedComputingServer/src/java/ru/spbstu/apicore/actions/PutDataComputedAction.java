package ru.spbstu.apicore.actions;

import java.math.BigInteger;
import ru.spbstu.apicore.computing.ComputingCenterHolder;
import ru.spbstu.apicore.computing.ComputingTaskResult;
import ru.spbstu.apicore.requests.PutDataComputedRequest;
import ru.spbstu.apicore.responses.PutDataComputedResponse;

/**
 *
 * @author igofed
 */
public class PutDataComputedAction implements IServerAction{

    @Override
    public Object process(Long id, Object request) throws ServerException {
        PutDataComputedRequest putDataComputed = (PutDataComputedRequest)request;
        
        BigInteger up = new BigInteger(putDataComputed.getUp());
        BigInteger down = new BigInteger(putDataComputed.getDown());
        
        ComputingTaskResult taskResult = new ComputingTaskResult();
        taskResult.setUp(up);
        taskResult.setDown(down);
        
        ComputingCenterHolder.getComputingCenter().loadComputedTask(id, taskResult);
        
        return new PutDataComputedResponse();
    }
    
}
