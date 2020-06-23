public abstract with sharing class Domain {
    protected List<SObject> records { get; private set; }

    protected Domain(List<SObject> records) {
        init(records);
    }

    protected virtual void init(List<SObject> records) {
        this.records = records;
    }


    public virtual void onBeforeInsert() {
    }
    public virtual void onBeforeUpdate(Map<Id,SObject> oldMap) {
    }
    public virtual void onBeforeDelete() {
    }

    public virtual void onAfterInsert(Map<Id,SObject> newMap) {
    }
    public virtual void onAfterUpdate(Map<Id,SObject> newMap) {
    }
    public virtual void onAfterDelete(Map<Id, SObject> oldMap) {
    }
    public virtual void onAfterUndelete() {
    }


    private void handleBeforeInsert() {
        onBeforeInsert();
    }

    private void handleBeforeUpdate() {
        onBeforeUpdate(Trigger.oldMap);
    }

    private void handleBeforeDelete() {
        onBeforeDelete();
    }

    private void handleAfterInsert() {
        onAfterInsert(Trigger.newMap);
    }

    private void handleAfterUpdate() {
        onAfterUpdate(Trigger.newMap);
    }

    private void handleAfterDelete() {
        onAfterDelete(Trigger.oldMap);
    }

    private void handleAfterUndelete() {
        onAfterUndelete();
    }

    public static void triggerHandler(Type handler) {
        if (handler == null) {
            return;
        }

        List<SObject> data  = Trigger.isDelete ? Trigger.old : Trigger.new;

        Domain d = (Domain)JSON.deserialize('{}', handler);
        d.init(data);

        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                d.handleBeforeInsert();
            } else if (Trigger.isUpdate) {
                d.handleBeforeUpdate();
            } else if (Trigger.isDelete) {
                d.handleBeforeDelete();
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                d.handleAfterInsert();
            } else if (Trigger.isUpdate) {
                d.handleAfterUpdate();
            } else if (Trigger.isDelete) {
                d.handleAfterDelete();
            } else if(Trigger.isUnDelete) {
                d.handleAfterUnDelete();
            }
        }
    }
}