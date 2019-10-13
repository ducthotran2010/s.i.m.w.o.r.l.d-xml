package test;

import thotd.dao.NetworkOperatorDAO;
import thotd.dao.SimDAO;
import thotd.dao.TagDAO;
import thotd.generated.Sim;
import thotd.resolvers.DataResolver;

import java.lang.reflect.InvocationTargetException;

public class DataResolverTest {

    public static void main(String[] args) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        NetworkOperatorDAO networkOperatorDAO = new NetworkOperatorDAO();
        TagDAO tagDAO = new TagDAO();
        SimDAO simDAO = new SimDAO();
        DataResolver dataResolver = new DataResolver();
        Sim sim = new Sim();
        sim.setPhoneNumber("0947857301");
        sim.setPrice(5000000);

        System.out.println("START TEST FUNCTIONALITY OF DATA-RESOLVER");
        System.out.println("------------------------------------------");


        System.out.println();
        System.out.println("INSERT");
//        System.out.println(dataResolver.insert(tagDAO, "Hihi"));
//        System.out.println(dataResolver.insert(networkOperatorDAO, "Hihi"));
        System.out.println(simDAO.getClass().getMethod("insert", Sim.class, int.class, int.class));
//        System.out.println(dataResolver.insert(simDAO, sim, 1, 1));

        System.out.println("UPDATE");
//        System.out.println((boolean) simDAO.getClass().getMethod("update", String.class).invoke(simDAO, ));
        System.out.println();
        System.out.println("GET ELEMENT BY ID");
//        System.out.println(new DataResolver().getIdByName(new NetworkOperatorDAO(), "huhu"));
//        System.out.println(new DataResolver().getIdByName(new TagDAO(), "toang"));

        System.out.println("------------------------------------------");
        System.out.println("END TEST FUNCTIONALITY OF DATA-RESOLVER");
    }
}
