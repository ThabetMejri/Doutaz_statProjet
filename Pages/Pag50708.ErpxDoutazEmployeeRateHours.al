page 50708 "Erpx Employee Rate Hours Card"
{
    Caption = 'Employee Rate Hours';
    PageType = Card;
    SourceTable = "Erpx Doutaz Rate hours Header";
    Editable = false;
    layout
    {
        area(content)
        {

            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field("Employment %"; Rec."Employment %")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Salary Amount Monthly"; Rec."Salary Amount Monthly")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Nb of Salary by year"; Rec."Nb of Salary by year")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Maximum LA"; Rec."Maximum LA")
                {
                    ApplicationArea = All;
                }
                field("Salary Amount Annually"; Rec."Salary Amount Annually")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Salary Amount Annually LAA"; Rec."Salary Amount Annually LAA")
                {
                    ApplicationArea = All;
                }
                field("Salary Amount Annually LAA/C"; Rec."Salary Amount Annually LAA/C")
                {
                    ApplicationArea = All;
                }
                field("Total annual social charges"; Rec."Total annual social charges")
                {
                    ApplicationArea = All;
                }
                field("Total annual employer charges"; Rec."Total annual employer charges")
                {
                    ApplicationArea = All;
                }
                field("Annual number of hours"; Rec."Annual number of hours")
                {
                    ApplicationArea = All;
                }
                field("Net hourly rate without FG"; Rec."Net hourly rate without FG")
                {
                    ApplicationArea = All;
                }
                field("General costs"; Rec."General costs")
                {
                    ApplicationArea = All;
                }
                field("Net hourly rate with FG"; Rec."Net hourly rate with FG")
                {
                    ApplicationArea = All;
                }

            }
            part(Lines; "Erpx doutaz Rate hours Line")
            {
                Caption = 'lines';
                SubPageLink = "Employee No." = field("Employee No.");
                ApplicationArea = all;

            }
        }

    }


}
