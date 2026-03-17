package com.priya.domain;

public class QuestionDto {

    private Integer qid;
    private String qname;
    private String opt1;
    private String opt2;
    private String opt3;
    private String opt4;
    private String correct_Opt;
    private String technoName;

    public QuestionDto() {
    }

    public Integer getQid() {
        return qid;
    }

    public void setQid(Integer qid) {
        this.qid = qid;
    }

    public String getQname() {
        return qname;
    }

    public void setQname(String qname) {
        this.qname = qname;
    }

    public String getOpt1() {
        return opt1;
    }

    public void setOpt1(String opt1) {
        this.opt1 = opt1;
    }

    public String getOpt2() {
        return opt2;
    }

    public void setOpt2(String opt2) {
        this.opt2 = opt2;
    }

    public String getOpt3() {
        return opt3;
    }

    public void setOpt3(String opt3) {
        this.opt3 = opt3;
    }

    public String getOpt4() {
        return opt4;
    }

    public void setOpt4(String opt4) {
        this.opt4 = opt4;
    }

    public String getCorrect_Opt() {
        return correct_Opt;
    }

    public void setCorrect_Opt(String correct_Opt) {
        this.correct_Opt = correct_Opt;
    }

    public String getTechnoName() {
        return technoName;
    }

    public void setTechnoName(String technoName) {
        this.technoName = technoName;
    }
}