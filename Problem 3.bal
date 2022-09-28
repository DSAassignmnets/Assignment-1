import ballerina/io;
import ballerina/http;

// record types for courses and student records
    type Courses record {|
    readonly string CourseCode;
    string Coursename;
    int testAssessmentweight;
    int assignmentAssessmentweight;
    int quizAssessmentweight;
    |};

    type studentDetail record {|
    string firstname;
    string lastname;
    readonly string studentnumber;
    string emailaddress;
    string[] courses;
    |};

    studentDetail[] all_students =[];
//define the data tables
    table<Courses> key(CourseCode) CoursesEntriesTable = table [
        {CourseCode: "DSA621S", Coursename: "Distributed Systems", testAssessmentweight: 40, assignmentAssessmentweight: 40, quizAssessmentweight: 20},
        {CourseCode: "IAR621S", Coursename: "Intrusion Analysis and Response", testAssessmentweight: 50, assignmentAssessmentweight: 30, quizAssessmentweight: 20},
        {CourseCode: "DFC721S", Coursename: "Digital Forensics 2", testAssessmentweight: 50, assignmentAssessmentweight: 25, quizAssessmentweight: 25},
        {CourseCode: "CMN621S", Coursename: "Communication networks", testAssessmentweight: 30, assignmentAssessmentweight: 40, quizAssessmentweight: 30},
        {CourseCode: "WLT21S", Coursename: "Wireless technologies", testAssessmentweight: 50, assignmentAssessmentweight: 50, quizAssessmentweight: 0},
        {CourseCode: "CIP621S", Coursename: "Critical Infrastructure and Protection", testAssessmentweight: 40, assignmentAssessmentweight: 40, quizAssessmentweight: 20}
    ];

        table<studentDetail> key(studentnumber) studentDetailEntriesTable = table [
        {firstname: "", lastname: "", studentnumber: "", emailaddress: "", courses: []}
    ];

service /students on new http:Listener(8080) {
    resource function get all() returns studentDetail[]? {
        io:print("hangling the GET request to all students");
        return all_students;
    }
    // function to add new student 
    resource function post insert (@http:Payload studentDetail? new_student) returns json {
        io:print("Handle POST request to /student/insert");
        all_students.push(<studentDetail>new_student);
        return {done: "OK"};
    }
    // function to lookup single student (filter)
    resource function get filter (string studentnumber) returns typedesc<studentDetail>{
        // space indicates ignoring of unused variable
        studentDetail? studentdetail = studentDetailEntriesTable[studentnumber];
        if studentdetail is studentDetail {
            return studentDetail;
        }
        // not sure how to solve error without return will cause function
        // to not operate
        return;
    }
    
    // function to delete student
}

