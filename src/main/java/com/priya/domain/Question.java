package com.priya.domain;

import jakarta.persistence.*;

@Entity
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer qid;

    private String qname;
    private String opt1;
    private String opt2;
    private String opt3;
    private String opt4;

    private String correct_Opt;

    @ManyToOne
    @JoinColumn(name = "techId")
    private Techno techId;

    private String imagePath;

    /** "MCQ" (default) or "SUBJECTIVE" */
    private String questionType = "MCQ";

    /** For SUBJECTIVE questions: the model answer faculty provides for AI grading */
    @Column(columnDefinition = "TEXT")
    private String referenceAnswer;

    public Question() {
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

    public Techno getTechId() {
        return techId;
    }

    public void setTechId(Techno techId) {
        this.techId = techId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getQuestionType() {
        return questionType != null ? questionType : "MCQ";
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getReferenceAnswer() {
        return referenceAnswer;
    }

    public void setReferenceAnswer(String referenceAnswer) {
        this.referenceAnswer = referenceAnswer;
    }
}