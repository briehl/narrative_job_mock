from NarrativeJobService.NarrativeJobServiceClient import NarrativeJobService

BATCH_APP_ID = "kb_BatchApp/run_batch"
BATCH_APP_METHOD = "kb_BatchApp.run_batch"


class StateMocker(object):
    def __init__(self, cfg, token):
        self.cfg = cfg
        self.njs_url = self.cfg['njsw-url']
        self.token = token
        self.njs = NarrativeJobService(url=self.njs_url, token=token)

    def check_job(self, job_id):
        status = self.check_jobs([job_id], True)
        return status['job_states'].get(job_id, status['check_error'].get(job_id))

    def check_jobs(self, job_list, with_job_params):
        stats = self.njs.check_jobs({'job_ids': job_list, 'with_job_params': 1})
        for job_id in stats['job_params']:
            app_info = stats['job_params'][job_id]
            if app_info.get('app_id') == BATCH_APP_ID or app_info.get('method') == BATCH_APP_METHOD:
                stats['job_states'][job_id]['child_jobs'] = self._build_mock_batch(
                    job_id, app_info, stats['job_states'][job_id]
                )
        if not with_job_params:
            del stats['job_params']
        return stats

    def _build_mock_batch(self, job_id, app_info, app_status):
        """
        Builds a list of mocked batch infos by using the list of inputs (in app_info)
        """
        mocked_status = list()
        for i, param_set in enumerate(app_info['params'][0].get('params', [])):
            mock_job_id = "{}_{}".format(job_id, i)
            mock_status = self._mock_job_status(i, mock_job_id, app_status)
            mocked_status.append(mock_status)
        return mocked_status

    def _mock_job_status(self, order, job_id, parent_status):
        status_order = ["running", "error", "completed"]
        current_state = order % len(status_order)
        job_status = {
            "job_id": job_id,
            "canceled": parent_status.get("canceled", 0),
            "cancelled": parent_status.get("cancelled", 0),
            "creation_time": parent_status.get("creation_time", 0),
            "exec_start_time": parent_status.get("exec_start_time", 0),
            "finish_time": parent_status.get("finish_time", 0),
            "job_state": status_order[current_state],
            "status": []
        }
        if status_order[current_state] == "error":
            job_status["error"] = {
                "code": -32000,
                "error": "An error occurred while running this child job. If this weren't a mockup, you should be worried.",
                "message": "A dummy error happened.",
                "name": "Mock Error"
            }
        elif status_order[current_state] == "completed":
            job_status["result"] = [{
                "report_ref": "123/45",
                "report_name": "dummy_report"
            }]
        return job_status
