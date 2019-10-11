package thotd.dto;

import java.io.Serializable;

public class AccountDTO implements Serializable {
    private String username;
    private String fullName;

    public AccountDTO(String username, String fullname) {
        this.username = username;
        this.fullName = fullname;
    }

    public String getUsername() {
        return username;
    }

    public String getFullName() {
        return fullName;
    }
}
