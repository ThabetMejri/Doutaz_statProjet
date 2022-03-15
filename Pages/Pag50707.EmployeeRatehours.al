page 50707 "Erpx Employee Rate hours List"
{
    ApplicationArea = All;
    Caption = 'Employee Rate hours';
    PageType = List;
    SourceTable = "Erpx Doutaz Rate hours Header";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Erpx Employee Rate Hours Card";
    layout
    {
        area(content)
        {
            repeater(General)
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
                }
                field("Net hourly rate without FG"; Rec."Net hourly rate without FG")
                {
                    ApplicationArea = All;
                }
                field("Net hourly rate with FG"; Rec."Net hourly rate with FG")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CalculateRateHourly)
            {
                Caption = 'Calculate Rate Hourly';
                RunObject = report "Erpx Doutaz Calcul Rate hourly";
                ApplicationArea = all;
                PromotedCategory = Process;
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedIsBig = true;
            }
        }
    }
}
