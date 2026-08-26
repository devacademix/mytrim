import { CanDeactivate } from '@angular/router';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { UtilService } from '../services/util.service';

export interface ComponentCanDeactivate {
  canDeactivate: () => boolean | Observable<boolean>;
}

@Injectable()
export class AwaitLeaveGuard implements CanDeactivate<ComponentCanDeactivate> {
  constructor(
    public util: UtilService
  ) { }
  canDeactivate(component: ComponentCanDeactivate): boolean | Observable<boolean> {
    console.log('ok closed this stufff');
    this.util.updatePaymentIssue();
    return true;
  }
};
