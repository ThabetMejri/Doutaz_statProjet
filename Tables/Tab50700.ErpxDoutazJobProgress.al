table 50700 ErpxDoutazJobProgress
{
    Caption = 'Job Progress';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
        }
        field(2; Change; Integer)
        {
            Caption = 'Change';
            DataClassification = ToBeClassified;
        }
        field(3; "% Overhead Rate"; Decimal)
        {
            Caption = '% Overhead Rate';
            DataClassification = ToBeClassified;
        }
        field(4; "% Job Progress"; Decimal)
        {
            Caption = '% Job Progress';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; Value; Decimal)
        {
            Caption = 'Value';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Job No.", Change)
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        LastProgress := 0;
        JobProgress.Reset();
        JobProgress.SetRange("Job No.", Rec."Job No.");
        if JobProgress.FindLast() then begin
            if Rec.Change < JobProgress.Change then
                Error(MsgError);
        end;
    end;

    trigger OnDelete()
    begin
        LastProgress := 0;
        JobProgress.Reset();
        JobProgress.SetRange("Job No.", Rec."Job No.");
        if JobProgress.FindLast() then begin
            if Rec.Change < JobProgress.Change then
                Error(MsgError);
        end;
    end;

    var
        JobProgress: Record ErpxDoutazJobProgress;
        LastProgress: Integer;
        MsgError: Label 'You can change only the last line.';

}
