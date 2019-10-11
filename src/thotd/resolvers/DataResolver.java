package thotd.resolvers;

import thotd.dao.NetworkOperatorDAO;
import thotd.dao.SimDAO;
import thotd.dao.TagDAO;
import thotd.generated.NetworkOperator;
import thotd.generated.NetworkOperators;
import thotd.generated.Sim;
import thotd.generated.Tag;
import thotd.utils.JAXBUtil;

import javax.xml.bind.JAXBException;
import javax.xml.transform.dom.DOMResult;
import java.io.Serializable;

public class DataResolver implements Serializable {
    NetworkOperatorDAO networkOperatorDAO;
    TagDAO tagDAO;
    SimDAO simDAO;

    public DataResolver() {
        networkOperatorDAO = new NetworkOperatorDAO();
        tagDAO = new TagDAO();
        simDAO = new SimDAO();
    }

    public void saveDomResultToDatabase(DOMResult domResult) throws JAXBException {
        String networkOperatorName;
        Integer networkOperatorId;
        String tagName;
        Integer tagId;
        NetworkOperators networkOperators = new NetworkOperators();
        networkOperators = (NetworkOperators) JAXBUtil.unmarshal(networkOperators.getClass(), domResult.getNode());

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
                if (tagId == null) {
                    continue;
                }

                for (Sim sim : tag.getSim()) {
                    handleInsertSim(sim, networkOperatorId, tagId);
                }
            }
        }
    }

    private boolean handleInsertSim(Sim sim, int networkOperatorId, int tagId) {
        boolean result = false;
        try {
            result = simDAO.insert(sim, networkOperatorId, tagId);
        } catch (Exception e) {
            try {
                result = simDAO.update(sim, networkOperatorId, tagId);
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

}
