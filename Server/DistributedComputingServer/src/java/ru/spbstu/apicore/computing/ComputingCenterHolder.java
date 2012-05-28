package ru.spbstu.apicore.computing;

/**
 *
 * @author igofed
 */
public class ComputingCenterHolder {

    private static IComputingCenter computingCenter;
    
    static{
        computingCenter = new ComputingCenter();
    }
    
    public static IComputingCenter getComputingCenter(){
        return computingCenter;
    }
}
