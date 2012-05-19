package ru.spbstu.apicore.actions;

import ru.spbstu.apicore.computing.ComputingCenterHolder;
import ru.spbstu.apicore.computing.ComputingTask;
import ru.spbstu.apicore.requests.GetDataToComputeRequest;
import ru.spbstu.apicore.responses.GetDataToComputeResponse;

/**
 *
 * @author igofed
 */
public class GetDataToComputeAction implements IServerAction {

    @Override
    public Object process(Long id, Object request) throws ServerException {
        
        GetDataToComputeRequest getDataRequest = (GetDataToComputeRequest)request;
        
        ComputingTask task = ComputingCenterHolder.getComputingCenter().getNewTask(id);
        
        GetDataToComputeResponse response = new GetDataToComputeResponse();
        response.setFrom(task.getFrom());
        response.setTo(task.getTo());
        
        return response;
    }    
}
