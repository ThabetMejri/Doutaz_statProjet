page 50702 "Erpx Order Progress"
{

    Caption = 'Order Progress';
    PageType = List;
    SourceTable = "Erpx Doutaz Order Progress";
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field(Change; Rec.Change)
                {
                    ApplicationArea = All;
                }
                field("% Overhead Rate"; Rec."% Overhead Rate")
                {
                    ApplicationArea = All;
                }
                field("% Job Progress"; Rec."% Job Progress")
                {
                    ApplicationArea = All;
                }
                field("Order Amount HT"; Rec."Order Amount HT")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Amount HT"; Rec."Amount HT")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
