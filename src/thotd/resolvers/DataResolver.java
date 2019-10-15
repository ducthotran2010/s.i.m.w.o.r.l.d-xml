package thotd.resolvers;

import thotd.dao.*;
import thotd.generated.*;
import thotd.generated.orders.Order;
import thotd.generated.orders.Orders;
import thotd.generated.phongthuy.PhongThuy;
import thotd.generated.phongthuy.Section;
import thotd.utils.JAXBUtil;
import thotd.utils.PhongThuyUtil;

import javax.xml.bind.JAXBException;
import javax.xml.transform.dom.DOMResult;
import java.io.Serializable;

public class DataResolver implements Serializable {

    public void saveDomResultToDatabase(DOMResult domResult) throws JAXBException {
        NetworkOperatorDAO networkOperatorDAO = new NetworkOperatorDAO();
        TagDAO tagDAO = new TagDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        Integer supplierId = null;
        String networkOperatorName;
        Integer networkOperatorId;
        String tagName;
        Integer tagId;
        Integer phongThuyId;
        NetworkOperators networkOperators = new NetworkOperators();
        networkOperators = (NetworkOperators) JAXBUtil.unmarshal(networkOperators.getClass(), domResult.getNode());

        String supplier = networkOperators.getSupplier().value();
        String website = networkOperators.getWebsite();

        try {
            supplierDAO.insert(supplier, website);
        } catch (Exception e) {}
        supplierId = handleGettingIdByNameGeneral(supplierDAO, supplier);

        if (supplierId == null) {
            return;
        }

        for (NetworkOperator networkOperator : networkOperators.getNetworkOperator()) {
            networkOperatorName = networkOperator.getName().value();
            handleInsertGeneral(networkOperatorDAO, networkOperatorName);

            networkOperatorId = handleGettingIdByNameGeneral(networkOperatorDAO, networkOperatorName);
            if (networkOperatorId == null) {
                continue;
            }

            for (Tag tag : networkOperator.getTag()) {
                tagName = tag.getName();
                handleInsertGeneral(tagDAO, tagName);
                tagId = handleGettingIdByNameGeneral(tagDAO, tagName);

                for (Sim sim : tag.getSim()) {
                    phongThuyId = PhongThuyUtil.getNumber(sim.getPhoneNumber());
                    handleInsertSim(sim, networkOperatorId, tagId, supplierId, phongThuyId);
                }
            }
        }
    }

    private boolean handleInsertSim(Sim sim, int networkOperatorId, Integer tagId, int supplierId, Integer phongThuyId) {
        SimDAO simDAO = new SimDAO();
        boolean result = false;

        try {
            result = simDAO.insert(sim, networkOperatorId, tagId, supplierId, phongThuyId);
        } catch (Exception e) {
            try {
                result = simDAO.update(sim, networkOperatorId, tagId, supplierId, phongThuyId);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        return result;
    }

    private boolean handleInsertGeneral(Object object, Object... args) {
        boolean result = false;
        try {
            result = (boolean) object.getClass().getMethod("insert", String.class).invoke(object, args);
        } catch (Exception e) {
            /* do nothing */
        }

        return result;
    }

    private Integer handleGettingIdByNameGeneral(Object object, Object... args) {
        try {
            return (Integer) object.getClass().getMethod("getIdByName", String.class).invoke(object, args);
        } catch (Exception e) {
            /* do nothing */
        }

        return null;
    }



    /**
     * Phong Thuy handle insert data
     */
    private boolean handleInsertOrder(Object object, Object... args) {
        boolean result = false;
        try {
            result = (boolean) object.getClass().getMethod("insert", Order.class).invoke(object, args);
        } catch (Exception e) {
            /* do nothing */
        }

        return result;
    }


    public void saveOrderDomResultToDatabase(DOMResult domResult) throws JAXBException {
        Orders orders = new Orders();
        orders = (Orders) JAXBUtil.unmarshal(orders.getClass(), domResult.getNode());
        OrderDAO orderDAO = new OrderDAO();
        for (Order order : orders.getOrder()) {
            handleInsertOrder(orderDAO, order);
        }
    }



    /**
     * Phong Thuy handle insert data
     */
    private boolean handleInsertPhongThuy(Object object, Object... args) {
        boolean result = false;
        try {
            result = (boolean) object.getClass().getMethod("insert", Section.class).invoke(object, args);
        } catch (Exception e) {
            /* do nothing */
        }

        return result;
    }

    public void savePhongThuyDomResultToDatebase(DOMResult domResult) throws JAXBException {
        PhongThuy phongThuy = new PhongThuy();
        phongThuy = (PhongThuy) JAXBUtil.unmarshal(phongThuy.getClass(), domResult.getNode());
        PhongThuyDAO phongThuyDAO = new PhongThuyDAO();
        for (Section section : phongThuy.getSection()) {
            handleInsertPhongThuy(phongThuyDAO, section);
        }
    }
}
